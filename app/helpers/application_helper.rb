module ApplicationHelper
    def user_avatar_helper(user, size, style_class)
        if user.avatar.blank?
            image_tag "Default-Avatar", size: size, class: style_class
        else
            image_tag user.avatar.url, size: size, class: style_class
        end
    end
end
