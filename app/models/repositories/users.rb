# frozen_string_literal: true

module SteamBuddy
  module Repository
    # Repository for Users
    class Users
      def self.find_id(steam_id64)
        rebuild_entity Database::UserOrm.first(steam_id64:)
      end

      def self.all
        Database::UserOrm.all.map { |db_user| rebuild_entity(db_user) }
      end

      def self.find(entity)
        find_id(entity.steam_id64)
      end

      def self.create(entity)
        raise 'User already exists' if find(entity)

        db_user = PersistUser.new(entity).call
        rebuild_entity(entity)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        # Notice: in users entity, there are played_gmaes & friend_list attributes
        # but in users db, these two attributes don't exist, so they got nil value
        Entity::User.new(
          steam_id64: db_record.steam_id64,
          steam_id: db_record.steam_id,
          game_count: db_record.game_count,
          played_games: nil,
          friend_list: nil
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Users.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        Database::UserOrm.find_or_create(entity.to_attr_hash)
      end

      # Helper class to persist user and its games to database
      class PersistUser
        def initialize(entity)
          @entity = entity
        end

        def create_user
          Database::UserOrm.create(@entity.to_attr_hash)
        end

        def call
          Users.db_find_or_create(@entity)

=begin
          create_user.tap do |db_user|
            db_user.update(owner:)

            @entity.contributors.each do |contributor|
              db_user.add_contributor(db_find_or_create(contributor))
            end
          end
=end
        end
      end
    end
  end
end
