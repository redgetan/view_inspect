module ViewInspect
  class Middleware
    HEAD_REGEXP = /(<head.*?>)/
    HTML_CONTENT_TYPE_REGEXP = /text\/html|application\/xhtml\+xml/

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if headers["Content-Type"] =~ HTML_CONTENT_TYPE_REGEXP && response.body.to_s =~ HEAD_REGEXP
        body = insert_view_inspect_script(response.body)
        headers["Content-Length"] = body.length.to_s
        response = [body]
      end

      [status, headers, response]
    end

    def insert_view_inspect_script(body)
      body  = add_library_exclude_list(body)
      index = get_insert_position(body)
      body.insert(index, get_inline_script)
      body
    end

    def add_library_exclude_list(body)
      index = body.index(HEAD_REGEXP)
      old_head = $1
      new_head = old_head.dup
      new_head.insert("<head".length, " data-orig-exclude-list='#{ViewInspect.library_exclude_list.join(",")}' ")
      body.sub(old_head,new_head)
    end

    def get_insert_position(body)
      index = body.index(HEAD_REGEXP)
      match = $1
      return index + match.length
    end

    def get_script
      filepath = File.expand_path("javascript_handler.js","#{File.dirname(__FILE__)}/../handlers")
      File.read(filepath)
    end

    def get_inline_script
      <<-CODE
        <script type="text/javascript" language="javascript" charset="utf-8">
        //<![CDATA[
          #{get_script}
        //]]>
        </script>
      CODE
    end
  end
end
