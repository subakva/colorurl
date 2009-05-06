require 'rubygems'
require 'sinatra'
require 'color'
require File.join(File.dirname(__FILE__), 'lib', 'color_ext')

set :public, 'public'
set :views,  'views'

get '/' do
  erb :index
end

get %r{/([\w]+)} do
  @rgb_color = Color::RGB.from_param(params[:captures].first)

  percentage_adjustments = ['lighten_by', 'darken_by', 'adjust_brightness', 'adjust_saturation', 'adjust_hue']
  percentage_adjustments.each do |param_name|
    next unless params.has_key?(param_name)
    @rgb_color = @rgb_color.send(param_name, params[param_name].to_i)
  end

  color_adjustment = {'adjust_red' => 'red_p', 'adjust_green' => 'green_p', 'adjust_blue' => 'blue_p'}
  color_adjustment.each do |param_name, method_name|
    next unless params.has_key?(param_name)
    @rgb_color.send("relative_#{method_name}=", params[param_name].to_i)
  end

  @rgb_color = @rgb_color.to_grayscale if params.has_key?('to_grayscale')
  @css_color = @rgb_color.html
  erb :color
end

use_in_file_templates!

__END__

@@ color

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title>colorurl</title>
  <style type='text/css' media='screen'>
    body {
      background-color: <%= @css_color %>;
    }
  </style>
</head>
<body>
  <!--
  <div id='controls'>
    <a href='?to_grayscale' title='Convert to Grayscale'>Grayscale</a><br/>
  </div>
  -->
</body>
</html>

@@ index

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title>colorurl</title>
  <style type='text/css' media='screen'>
    body {
      background-color: <%= @css_color %>;
    }
  </style>
</head>
  <p style='text-align:center'>
    Try:<br/>
    <a href='http://colorurl.local/mauve' title='mauve'>http://colorurl.local/mauve</a><br/>
    <a href='http://colorurl.local/CABBED' title='#CABBED'>http://colorurl.local/CABBED</a><br/>
    Get it?
  </p>
<body>
</body>
</html>
