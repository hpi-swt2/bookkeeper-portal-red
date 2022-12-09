module ApplicationHelper
  def language_flag(locale)
    updated_locale = if locale == :en
                       :us
                     else
                       locale
                     end
    content_class = "flag-icon flag-icon-#{updated_locale}"
    content_tag(:span, nil, class: content_class)
  end
end
