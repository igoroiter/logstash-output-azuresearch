# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "rest-client"
require "stud/buffer"

# An azuresearch output that does nothing.
class LogStash::Outputs::Azuresearch < LogStash::Outputs::Base
  config_name "azuresearch"
  
  # Azure Search Endpoint URL
  config :endpoint, :validate => :string, :required => true

  # zure Search API key
  config :api_key, :validate => :string, :required => true

  # Azure Search Index name to insert records
  config :search_index, :validate => :string, :required => true

  public
  def register
    require_relative 'azuresearch/client'
    @client = AzureSearch::Client.new(@endpoint, @api_key)
  end # def register

  public
  def receive(event)
    @client.add_documents(@search_index, event)
    rescue RestClient::ExceptionWithResponse => rcex
      exdict = JSON.parse(rcex.response)
      $logger.error("RestClient Error: '#{rcex.response}', data=>" + (documents.to_json).to_s)
    rescue => ex
      $logger.error( "Error: '#{ex}'" + ", data=>" + (documents.to_json).to_s)
      
    return "Event received #{event}"     
  end # def event
end # class LogStash::Outputs::Azuresearch
