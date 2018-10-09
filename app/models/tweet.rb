class Tweet < ApplicationRecord
    belongs_to :user

    mount_uploader :image, ImageUploader

    has_many :tweet_tags
    has_many :tags, through: :tweet_tags

    paginates_per 3

    before_validation :link_check, :add_username, on: :create

    validates :message, presence: true
    validates :message, length: { maximum: 140, too_long: 'A tweet is only 140 max. Everybody knows that!' }, on: :create

    after_validation :apply_link, :image_url_to_string, on: :create

    def self.search(search)
        where('message LIKE ?', "%#{search}%")
    end

    private

        def add_username
            self.message = self.message + "<p hidden> #{self.user.username}</p>"
        end

        def image_url_to_string
            @image_url_string = self.image.url.to_s
        end

        def link_check
            check = false
            if self.message.include? "http://"
                check = true
            elsif self.message.include? "https://"
                check = true
            else
                check = false
            end

            if check == true
                arr = self.message.split
                index = arr.map{ |x| x.include? "http"}.index(true)
                self.link = arr[index]
                if arr[index].length > 23
                    arr[index] = "#{arr[index][0..20]}..."
                end

                self.message = arr.join(" ")
            end
        end

        def apply_link
            arr = self.message.split
            index = arr.map { |x| x.include?("http://") || x.include?("https://") }.index(true)
            if index
                url = arr[index]
                arr[index] = "<a href='#{self.link}' target='_blank'>#{url}</a>"
            end

            self.message = arr.join(" ")
        end
end
