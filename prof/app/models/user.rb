class User < ApplicationRecord
	has_many :children, class_name: "User", foreign_key: "parent_id" , dependent: :destroy
	belongs_to :parent, class_name: "User", optional: true, foreign_key: "parent_id"
	validates_presence_of :full_name, :username, :email_id, :phone_number
	validates_uniqueness_of :username, :phone_number, :email_id
	validates :phone_number, presence: true,length: {minimum:10, maximum:10}, numericality: { only_integer: true }
	enum status: [:buyer, :seller, :broker]
	has_secure_password
	validate :horizontal_validate, on: [:update, :create]
	validate :vertical_validate, on: [:update, :create]

	def horizontal_validate
		#byebug
		#@user = User.find_by(id: id)
		@user_parent = User.find_by(id: parent_id)
		if @user_parent.children.count >= 4
			errors.add(:horizontal_validate, "Children can't be greater than 4")
		end
	end

	def vertical_validate
		@user = User.find_by(id: id)
		@user_parent = User.find_by(id: parent_id)
		 #@user_parent = @user.parent
      	#@user_parent_parent =  @user_parent.parent
      	#@user_children = @user.children
		#@user_parent_parent = @user_parent.parent
		if @user_parent.present?
			if @user_parent.parent.present?
				if !(@user_parent.parent.parent_id == nil  && @user.children.count == 0)
					errors.add(:grandchild, "Cant add because parent is grandchild")    	
    			end
    		elsif !(@user_parent.parent_id == nil && @user.children.count > 0)
    			errors.add(:parent, "Cant add because user has children and parent both")
    		end
    	else 
			@user.children.each do |d| 
 				 if d.children.present?
 				 			errors.add(:grandparent, "cant add because user is grandparent")
 				 		end
 				 	end
 				 
 		end

	end







	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	after_commit on: [:create] do
		__elasticsearch__.index_document
	end

	after_commit on: [:update] do
		__elasticsearch__.update_document
	end
=begin def self.search(query)
	 __elasticsearch__.search(
	  {
	   query: {
	    multi_match: {
	     query: query,
	     fields: [:username, :email_id, :phone_number]
	    }
	   }
	  }
	 )
  end
=end
		def self.search(query)
		__elasticsearch__.search({
			query: {
				multi_match: {
						fields: [:username, :email_id, :phone_number],
            			query: query,
            			type: "phrase_prefix"
				}
			}
		}
		)
		end

	settings index: { number_of_shards: 1} do
		mapping dynamic: false do
		indexes :username, type: 'keyword'
		indexes :email_id, type: 'keyword'
		indexes :phone_number, type: 'keyword'
		end
		end
	end

=begin
		def self.es_search_result(params)
			field = params[:field]
			query = params[:query]
			data = self.__elasticsearch__.search({
				query: {
					bool: {
						must: [{
							term: {
								"#{field}":"#{query}"
							}
						}]
					}
				}
			}).records
			return data
		end
=end

=begin
		def self.search_record(params)
			return es_search_result(params)
		end

		def as_indexed_json(options={})
			{
				"username" => username,
				"email_id" => email_id,
				"phone_number" => phone_number,
				"created_at" => created_at
			}
		end
			def self.insertion_in_es 
				User.__elasticsearch__.client.indices.create \
				index: User.index_name, body: { settings: User.settings.to_hash, mappings: User.mappings.to_hash }

				User.find_each do |i|
					i.__elasticsearch__.index_document
				end
			end
=end




