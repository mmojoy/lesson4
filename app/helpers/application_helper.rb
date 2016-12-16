module ApplicationHelper
	def sort_link(column, title = nil)
		title ||= column.titleize
		direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
		klass = column == sort_column ? 'current' + ' ' + sort_direction.to_s : nil
		link_to title.to_s, { column: column, direction: direction }, class: klass.to_s, remote: true
	end

	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(current_user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		image_tag(gravatar_url, alt: current_user.name, class: "gravatar")
	end
end
