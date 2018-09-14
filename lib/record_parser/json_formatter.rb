require "json"

class RecordParser
  module JsonFormatter
    class << self
      def jsonify(data_structure)
        json_structure_for(data_structure).to_json
      end

      # Return only one of: Hash, Array, String, Integer, Float, Date.
      # Hashes and Arrays must only be composed of these classes as
      # well.
      #
      def json_structure_for(object)
        case object

        when Hash
          Hash[object.map do |key, value|
            [json_structure_for(key), json_structure_for(value)]
          end]

        when Array
          object.map { |value| json_structure_for(value) }

        when Record
          Hash[Record::FIELDS.map do |field_name|
            [field_name.to_s, json_structure_for(object.send(field_name))]
          end]

        when RecordSet
          object.list_records.map do |record|
            json_structure_for(record)
          end

        when String, Integer, Float, Date
          object

        else
          object.to_s
        end
      end
    end
  end
end
