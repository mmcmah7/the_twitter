class Tweet < ApplicationRecord
	belongs_to :user

	has_many :tweet_tags
	has_many :tags, through: :tweet_tags

	before_validation :link_check, on: :create
	validates :message, presence: true
	validates :message, length: {maximum: 250, too_long: "- if you need more than 250 characters, write a blog."}, on: :create
	after_validation :apply_link, on: :create

private
	def link_check
		if self.message.include? "https://"
			arr = self.message.split
			indx = arr.map { |x| x.include? "https://"}.index(true)
			self.link = arr[indx]

			if arr[indx].length > 23
				arr[indx] = "#{arr[indx][0..20]}..."
			end

			self.message = arr.join(" ")
		end	
	end
	def apply_link
		arr = self.message.split
		indx = arr.map { |x| x.include? "https://"}.index(true)
		if indx
		url = arr[indx]

		arr[indx] = "<a href='#{self.link}' target='_blank' >#{url} </a>"
		end
		self.message = arr.join(" ")
	end


end
