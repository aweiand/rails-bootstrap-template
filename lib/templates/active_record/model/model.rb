<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>

<% attributes.select(&:reference?).each do |attribute| -%>
	belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: true' if attribute.required? %>
<% end -%>

<% attributes.select(&:token?).each do |attribute| -%>
	has_secure_token<% if attribute.name != "token" %> :<%= attribute.name %><% end %>
<% end -%>

<% if attributes.any?(&:password_digest?) -%>
	has_secure_password
<% end -%>

	# after_create :save_log
	# after_update :save_log_update
	
	# filterrific(
	# 	default_filter_params: { sorted_by: "updated_at_asc" },
	# 	available_filters: [
	# 		:sorted_by,
	# 		:search_query,
	# 	],
	# )

 	scope :search_query, ->(query) {
		return nil if query.blank?

		terms = query.to_s.downcase.split(/\s+/)
		terms = "%" + terms.join("%") + "%"

		where(
			"( unaccent(LOWER(fullname)) ILIKE unaccent(?) )", terms
		)
	}

	scope :sorted_by, ->(sort_key) {
		direction = /desc$/.match?(sort_key) ? "desc" : "asc"
		case sort_key.to_s
			when /^fullname/
				order(Arel.sql("LOWER (fullname) #{direction}"))
			when /^created_at_/
				order("created_at #{direction}")
			when /^updated_at_/
				order("updated_at #{direction}")            
		else
			raise(ArgumentError, "Invalid sort option: #{sort_key.inspect}")
		end
	}

	def self.options_for_sorted_by
		[
			["Data de cadastro (mais nova primeiro)", "created_at_desc"],
			["Data de cadastro (mais antiga primeiro)", "created_at_asc"],
			["Data de atualização (mais nova primeiro)", "updated_at_desc"],
			["Data de atualização (mais antiga primeiro)", "updated_at_asc"]
		]
	end

	def self.options_for_select
		order("fullname ASC").map { |e| [e.fullname, e.id] }
	end

end
<% end -%>