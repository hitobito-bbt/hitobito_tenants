# encoding: utf-8

#  Copyright (c) 2012-2017, hitobito AG. This file is part of
#  hitobito_tenants and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_tenants.

require 'apartment/adapters/abstract_adapter'

module Apartment
  module Adapters
    module Wagons

      extend ActiveSupport::Concern

      included do
        alias_method_chain :create, :wagons
      end

      def create_with_wagons(tenant)
        create_tenant(tenant)
        migrate(tenant)
      end

      def migrate(tenant)
        switch(tenant) do
          migrate_core
          seed # core
          migrate_wagons
          seed_wagons
        end
      end

      private

      def migrate_core
        ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, nil)
      end

      def migrate_wagons
        wagons.each { |wagon| wagon.migrate(nil) }
      end

      def seed_wagons
        wagons.each { |wagon| wagon.load_seed }
      end

      def wagons
        @wagons ||= ::Wagons.all
      end

    end
  end
end

Apartment::Adapters::AbstractAdapter.send(:include, Apartment::Adapters::Wagons)
Apartment::Tenant.def_delegators :adapter, :migrate