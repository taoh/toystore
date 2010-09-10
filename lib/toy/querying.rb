module Toy
  module Querying
    extend ActiveSupport::Concern

    module ClassMethods
      def get(id)
        load(store[store_key(id)])
      end

      def get!(id)
        get(id) || raise(Toy::NotFound.new(id))
      end

      def get_multi(*ids)
        ids.flatten.map { |id| get(id) }
      end

      def get_or_new(id)
        get(id) || new(:id => id)
      end

      def get_or_create(id)
        get(id) || create(:id => id)
      end

      def key?(id)
        store.key?(store_key(id))
      end
      alias :has_key? :key?

      def load(attrs)
        attrs = normalize_load_attributes(attrs)
        return nil if attrs.nil?
        allocate.initialize_from_database(attrs)
      end

      private
        def normalize_load_attributes(attrs)
          return nil if attrs.nil?
          attrs = Toy.decode(attrs) if attrs.is_a?(String)
          attrs
        end
    end
  end
end