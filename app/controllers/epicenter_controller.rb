class EpicenterController < ApplicationController
    before_action :authenticate_user!

    # Feed Action
    def feed
        @user = current_user

        following_tweets = []

        Tweet.all.each do |tweet|
            if current_user.following.include?(tweet.user_id) || current_user.id == tweet.user_id
                following_tweets.push(tweet)
            end
        end

        @paginate_following_tweets = Kaminari.paginate_array(following_tweets.reverse).page(params[:page]).per(5)

        # Following
        @following = []

        User.all.each do |user|
            if @user.following.include?(user.id)
                @following.push(user)
            end
        end

        # Followers
        @followers = []

        User.all.each do |user|
            if user.following.include?(@user.id)
                @followers.push(user)
            end
        end

        # Tags
        @top_tags = {}

        Tag.all.each do |tag|
            @top_tags[tag.id] = tag.tweets.length
        end

        @top_tags = @top_tags.sort_by{|k,v| v}.reverse

        # Tweeters
        @top_tweeters = {}

        User.all.each do |user|
            @top_tweeters[user.id] = user.tweets.length
        end

        @top_tweeters = @top_tweeters.sort_by{|k,v| v}.reverse
    end

    # Show User Action
    def show_user
        @user = User.find(params[:id])

        # Following
        @following = []

        User.all.each do |user|
            if @user.following.include?(user.id)
                @following.push(user)
            end
        end

        # Followers
        @followers = []

        User.all.each do |user|
            if user.following.include?(@user.id)
                @followers.push(user)
            end
        end
    end

    def all_users
        @users = User.all
        # or:
        # User.order(:username)
        # User.order(:name)
        # or whatever order we
        # want them in.
    end

    def now_following
        # We are adding the user.id of the user you want to
        # follow to your following array.
        # and we want to make sure it's saved in there as an integer
        current_user.following.push(params[:id].to_i)
        current_user.save

        redirect_to show_user_path(id: params[:id])
    end

    def unfollow
        current_user.following.delete(params[:id].to_i)
        current_user.save

        redirect_to show_user_path(id: params[:id])
    end

    def following
        @user = User.find(params[:id])
        @users = []

        User.all.each do |user|
            if @user.following.include?(user.id)
                @users.push(user)
            end
        end
    end

    def followers
        @user = User.find(params[:id])
        @users = []

        User.all.each do |user|
            if user.following.include?(@user.id)
                @users.push(user)
            end
        end
    end

    def tag_tweets
        @tag = Tag.find(params[:id])
    end
end
