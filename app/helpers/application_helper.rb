module ApplicationHelper
  def wrap_on_line_breaks text
    text.to_s.split(/(?:\n\r?|\r\n?)/).map {|s| "<p>#{h s}</p>"}.join.html_safe
  end
end
