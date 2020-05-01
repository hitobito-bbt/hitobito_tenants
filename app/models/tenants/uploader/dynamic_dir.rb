# encoding: utf-8

#  Copyright (c) 2012-2017, hitobito AG. This file is part of
#  hitobito_tenants and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_tenants.

module Tenants
  module Uploader
    module DynamicDir

      def base_store_dir
        "#{super}/#{Apartment::Tenant.current}"
      end

    end
  end
end
