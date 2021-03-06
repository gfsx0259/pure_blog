module Blog
  module Models
    class Validator
      attr_reader :invalid_params
      attr_reader :missing_params
      attr_reader :messages
      attr_reader :params
      attr_accessor :lazy_mode

      def initialize(params, lazy_mode = true)
        @params = params
        @invalid_params = []
        @missing_params = []
        @messages = []
        @lazy_mode = lazy_mode
      end

      def has_errors?
        !@invalid_params.empty? || !@missing_params.empty?
      end

      def trim(key)
        @params[key.to_s] = @params[key.to_s].strip if @params[key.to_s]
      end

      def downcase(key)
        @params[key.to_s] = @params[key.to_s].to_s.downcase if @params[key.to_s]
      end

      def required(keys)
        if lazy_check_disabled
          keys.each do |k|
            k = k.to_s
            next if @params.key?(k) && !@params[k].empty?
            @invalid_params.push(k)
            @missing_params.push(k)
            @messages.push(name: k, error: :REQUIRED, info: "#{k.capitalize} field is required")
          end
        end
      end

      def is_integer(key)
        if lazy_check_disabled
          key = key.to_s
          value = @params[key]
          unless is_valid_integer(value)
            @invalid_params.push(key)
            @messages.push(name: key, error: :NOT_INTEGER)
          end
        end
      end

      def is_float(key)
        if lazy_check_disabled
          key = key.to_s
          value = @params[key]
          unless is_valid_float(value)
            @invalid_params.push(key)
            @messages.push(name: key, error: :NOT_FLOAT)
          end
        end
      end

      def is_greater_equal_than(min, key)
        if lazy_check_disabled
          key = key.to_s
          if !is_valid_float(@params[key])
            if !@params[key] || @params[key].length < min
              @invalid_params.push(key)
              @messages.push(name: key, error: :LESS_THAN, value: min)
            end
          else
            value = is_valid_integer(@params[key]) ? @params[key].to_i : @params[key].to_f
            if !value || value < min
              @invalid_params.push(key)
              @messages.push(name: key, error: :LESS_THAN, value: min)
            end
          end
        end
      end

      def is_in_range(min, max, key)
        if lazy_check_disabled
          key = key.to_s
          if is_valid_float(@params[key])
            value = is_valid_integer(@params[key]) ? @params[key].to_i : @params[key].to_f
            if !value || value < min || value > max
              @invalid_params.push(key)
              @messages.push(name: key, error: :NOT_IN_RANGE, value: [min, max])
            end
          else
            if !@params[key] || @params[key].length < min || @params[key].length > max
              @invalid_params.push(key)
              @messages.push(name: key, error: :NOT_IN_RANGE, value: [min, max])
            end
          end
        end
      end

      def is_less_equal_than(max, key)
        if lazy_check_disabled
          key = key.to_s
          if is_valid_float(@params[key])
            value = is_valid_integer(@params[key]) ? @params[key].to_i : @params[key].to_f
            if !value || value > max
              @invalid_params.push(key)
              @messages.push(name: key, error: :GREATER_THAN, value: max)
            end
          else
            if !@params[key] || @params[key].length > max
              @invalid_params.push(key)
              @messages.push(name: key, error: :GREATER_THAN, value: max)
            end
          end
        end
      end

      def is_email(key)
        if lazy_check_disabled
          key = key.to_s
          unless @params[key].to_s[/^\S+@\S+\.\S+$/]
            @invalid_params.push(key)
            @messages.push(name: key, error: :NOT_VALID_EMAIL, info: "#{key.capitalize!} is incorrect email format ")
          end
        end
      end

      def is_set(array, key)
        if lazy_check_disabled
          key = key.to_s
          unless array.include? @params[key]
            @invalid_params.push(key)
            @messages.push(name: key, error: :NOT_IN_SET, value: array)
          end
        end
      end

      def is_boolean(key)
        if lazy_check_disabled
          key = key.to_s
          unless @params[key] == 'true' || @params[key] == 'false'
            @invalid_params.push(key)
            @messages.push(name: key, error: :NOT_BOOLEAN)
          end
        end
      end

      def matches(regexp, key)
        if lazy_check_disabled
          key = key.to_s
          unless @params[key] =~ regexp
            @invalid_params.push(key)
            @messages.push(name: key, error: :NOT_MATCHED, value: regexp)
          end
        end
      end

      def clean_parameters(all_parameters)
        @params.each_key do |key|
          @params.delete key.to_s unless all_parameters.include? key.to_s
        end
      end

      private

      def lazy_check_disabled
        !@lazy_mode || !has_errors?
      end

      def is_valid_integer(value)
        key = key.to_s
        value.to_i.to_s == value.to_s
      end

      def is_valid_float(value)
        key = key.to_s
        value.to_f.to_s == value.to_s || is_valid_integer(value)
      end

      module Sinatra
        def validation_required(method, path, options = {})
          before path do
            validate_parameters(options) if same_method? method
          end
      end

        module Helpers
          def same_method?(method)
            @env['REQUEST_METHOD'] == method.to_s
          end

          def validate_parameters(options)
            validator = Validator.new params, false
            all_params = []
            required_params = []
            integer_params = []
            float_params = []
            email_params = []
            range_params = []
            set_params = []
            boolean_params = []
            matches_params = []
            default_params = []
            action_params = []

            options[:params].each do |param|
              all_params << param[:name].to_s
              required_params << (param[:name]) if param[:required]
              integer_params << param if param[:type] == :integer
              float_params << param if param[:type] == :float
              email_params << param if param[:type] == :email
              range_params << param if param[:range]
              set_params << param if param[:set]
              boolean_params << param if param[:type] == :boolean
              matches_params << param if param[:matches]
              default_params << param if param[:default]
              action_params << param if param[:action]
            end

            validator.clean_parameters all_params

            validator.required required_params

            integer_params.each do |param|
              validator.is_integer param[:name] unless params[param[:name].to_s].nil?
            end
            float_params.each do |param|
              validator.is_float param[:name] unless params[param[:name].to_s].nil?
            end
            email_params.each do |param|
              validator.is_email param[:name] unless params[param[:name].to_s].nil?
            end
            range_params.each do |param|
              validator.is_in_range param[:range].first, param[:range].last, param[:name] unless params[param[:name].to_s].nil?
            end
            set_params.each do |param|
              validator.is_set param[:set], param[:name] unless params[param[:name].to_s].nil?
            end
            boolean_params.each do |param|
              validator.is_boolean param[:name] unless params[param[:name].to_s].nil?
            end
            matches_params.each do |param|
              validator.matches param[:matches], param[:name] unless params[param[:name].to_s].nil?
            end

            default_params.each do |param|
              next unless params[param[:name].to_s].nil?
              params[param[:name].to_s] = param[:default]
              validator.invalid_params.delete param[:name]
              validator.missing_params.delete param[:name]
            end

            action_params.each do |param|
              validator.downcase param[:name] if param[:action].include? :downcase
              validator.trim param[:name] if param[:action].include? :trim
            end

            if validator.has_errors?
              @env['validator.missing'] = validator.missing_params
              @env['validator.invalid'] = validator.invalid_params
              @env['validator.messages'] = validator.messages
            end
          end
        end

        def self.registered(base)
          base.helpers Helpers
        end
        end
    end
  end
end
