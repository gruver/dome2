class LightsController < ApplicationController
    CONFIG_FILE = '../data/state.json'

    def index
        @config = ''
        begin
            @config = File.read(CONFIG_FILE)
        rescue => ex
        end
    end

    def set_config
        puts "\nSET CONFIG\n"

        key = params[:key]
        value = params[:value]        

        puts "#{key} : #{value}"

        config = nil
        begin
            config_str = File.read(CONFIG_FILE) || ''
            config = JSON.parse(config_str).with_indifferent_access
        rescue => ex
            config = {}.with_indifferent_access
        end

        config[key] = value
        File.write(CONFIG_FILE, config.to_json)

        render :json => config
    end
end
