module ApplicationHelper

    def language_flag(locale)
        if locale == :en
            updated_locale = :us
          else
            updated_locale = locale
          end
        content_class = "flag-icon flag-icon-#{updated_locale}"
        content_tag(:span, nil, class: content_class)
    end
end
