module AzureSearch

  API_VERSION = '2015-02-28'.freeze
  MAX_DOCS_PER_INDEX_UPLOAD = 1000.freeze

  class Client
    def initialize(api_url, api_key, api_version=AzureSearch::API_VERSION)
      require 'rest-client'
      require 'json'
      @api_url = api_url
      @api_key = api_key
      @api_version = api_version
      @headers = {
          'Content-Type' => "application/json; charset=UTF-8",
          'Api-Key' => api_key,
          'Accept' => "application/json",
          'Accept-Charset' => "UTF-8"
        }
    end
    
    public
    def send_docs(index_name, docs, merge=true)
      raise ConfigError , 'index_name missing' if index_name.empty?
      raise ConfigError , 'docs missing' if docs.empty?
      action = merge ? 'mergeOrUpload' : 'upload' 
      for doc in docs
        doc['@search.action'] = action    
      end
      
      req = {value: docs}.to_json
      res = RestClient.post(
        "#{api_url}/indexes/#{index_name}/docs/index?api_version=#{api_version}",
        req,
        @headers
      )
    end
  end
end
