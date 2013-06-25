module IMS::LTI
  # Mixin module for managing LTI Launch Data
  #
  # Launch data documentation:
  # http://www.imsglobal.org/lti/v1p1pd/ltiIMGv1p1pd.html#_Toc309649684
  module Params
    def params
      @params ||= {}
    end

    def params=(params)
      @params = {}
      params.each{|key, val| self.send("#{key}=", val)}
    end

    alias_method :to_params, :params

    attr_writer :non_spec_params
    def non_spec_params
      @non_spec_params ||= {}
    end

    def set_param(key, val)
      params[key.to_s] = val
    end

    def get_param(key)
      params[key.to_s]
    end

    def set_ext_param(key, val)
      params["ext_#{key}"] = val
    end

    def get_ext_param(key)
      params["ext_#{key}"]
    end

    def set_custom_param(key, val)
      params["custom_#{key}"] = val
    end

    def get_custom_param(key)
      params["custom_#{key}"]
    end

    #TODO: use non_spec_params
    def set_non_spec_param(key, val)
      non_spec_params[key.to_s] = val
    end

    def get_non_spec_param(key)
      non_spec_params[key.to_s]
    end

    # Set the roles for the current launch
    #
    # Full list of roles can be found here:
    # http://www.imsglobal.org/LTI/v1p1pd/ltiIMGv1p1pd.html#_Toc309649700
    #
    # LIS roles include:
    # * Student
    # * Faculty
    # * Member
    # * Learner
    # * Instructor
    # * Mentor
    # * Staff
    # * Alumni
    # * ProspectiveStudent
    # * Guest
    # * Other
    # * Administrator
    # * Observer
    # * None
    #
    # @param roles_list [String,Array] An Array or comma-separated String of roles
    def roles=(roles_list)
      if roles_list
        if roles_list.is_a?(Array)
          params['roles'] = roles_list.join(',')
        else
          params['roles'] = roles_list
        end
        params['roles'].downcase!
      else
        params['roles'] = nil
      end
    end

    def roles
      return [] unless params['roles']
      if params['roles'].is_a?(Array)
        params['roles']
      else
        params['roles'].split(',')
      end
    end

    def lti_version
      params['lti_version'] ||= 'LTI-2p0'
    end

    def method_missing(method, *args, &block)
      if args.length == 0
        get_param(method)
      elsif args.length == 1
        set_param(method.to_s.sub('=', ''), args.first)
      else
        super # You *must* call super if you don't handle the
              # method, otherwise you'll mess up Ruby's method
              # lookup.
      end
    end
  end
end