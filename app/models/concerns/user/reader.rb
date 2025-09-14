module User::Reader
  extend ActiveSupport::Concern

  def avatar
    return "https://ui-avatars.com/api/?name=#{ERB::Util.url_encode(full_name)}&background=random&size=128&color=fff" if full_name.present?

    "https://ui-avatars.com/api/?name=User&background=random&size=128&color=fff"
  end

  def tenant_cache_key
    Settings.cache.current_tenant % { user_id: id }
  end
end
