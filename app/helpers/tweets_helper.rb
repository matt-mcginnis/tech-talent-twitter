module TweetsHelper
    def get_tagged(tweet)
        message_arr = [] # Holds each word of our tweet
        message_arr = tweet.message.split
        message_arr.each_with_index do |word, index|
            next unless word[0] == '#'

            tag = if Tag.pluck(:phrase).include?(word.downcase)
                      Tag.find_by(phrase: word.downcase)
                  else
                      Tag.create(phrase: word.downcase)
                  end
            tweet_tag = TweetTag.create(tweet_id: tweet.id, tag_id: tag.id)
            message_arr[index] = "<a href='/tag_tweets?id=#{tag.id}'>#{word}</a>"
        end

        tweet.message = message_arr.join(' ')
        return tweet
    end
end
