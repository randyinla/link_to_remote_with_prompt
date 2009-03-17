module ActionView
  module Helpers
    module PrototypeHelper
      def remote_function(options)
        javascript_options = options_for_ajax(options)

        update = ''
        if options[:update] && options[:update].is_a?(Hash)
          update  = []
          update << "success:'#{options[:update][:success]}'" if options[:update][:success]
          update << "failure:'#{options[:update][:failure]}'" if options[:update][:failure]
          update  = '{' + update.join(',') + '}'
        elsif options[:update]
          update << "'#{options[:update]}'"
        end

        function = update.empty? ? 
          "new Ajax.Request(" :
          "new Ajax.Updater(#{update}, "

        url_options = options[:url]
        url_options = url_options.merge(:escape => false) if url_options.is_a?(Hash)
        function << "'#{escape_javascript(url_for(url_options))}'"
        function << ", #{javascript_options})"

        function = "#{options[:before]}; #{function}" if options[:before]
        function = "#{function}; #{options[:after]}"  if options[:after]
        function = "if (#{options[:condition]}) { #{function}; }" if options[:condition]
        function = "if (confirm('#{escape_javascript(options[:confirm])}')) { #{function}; }" if options[:confirm]
        function = "var prompt_reply = prompt('#{escape_javascript(options[:prompt])}');if(prompt_reply) { #{function}; }" if options[:prompt]

        return function
      end
    end
  end
end