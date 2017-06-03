# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"

# An azuresearch output that does nothing.
class LogStash::Outputs::Azuresearch < LogStash::Outputs::Base
  config_name "azuresearch"

  public
  def register
  end # def register

  public
  def receive(event)
    return "Event received"
  end # def event
end # class LogStash::Outputs::Azuresearch
