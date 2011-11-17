helpers do
  def link_to(text, url, opts = {})
    attributes = ""
    opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end

  def score_percentages(scores)
    scores.sort{ |a, b| b[1] <=> a[1] }.map do |s|
      "#{s[0].capitalize}: #{'%.2f' % (s[1] * 100)}%"
    end.join(', ')
  end
end
