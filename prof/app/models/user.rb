class User < ApplicationRecord
	validates_presence_of :full_name, :username, :email_id, :phone_number
	validates_uniqueness_of :username, :phone_number, :email_id
	validates :phone_number, presence: true,length: {minimum:10, maximum:10}, numericality: { only_integer: true }
	enum status: [:buyer, :seller, :broker]
	has_secure_password
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	after_commit on: [:create] do
		__elasticsearch__.index_document
	end

	after_commit on: [:update] do
		__elasticsearch__.update_document
	end
			def self.search(query)
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




