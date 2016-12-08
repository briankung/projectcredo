module ApplicationHelper
  def wrap_on_line_breaks text
    text.to_s.split(/(?:\n\r?|\r\n?)/).map {|s| autolink "<p>#{h s}</p>"}.join.html_safe
  end

  def autolink text
    text.gsub(URI::regexp(%w(http https))) {|match| link_to match, match}
  end
end
