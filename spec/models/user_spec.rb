# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe '#timezone' do
    subject(:user) { described_class.new }

    it 'validates inclusion of timezone' do
      user.timezone = 'invalid/timezone'
      expect(user).not_to be_valid
      expect(user.errors[:timezone]).to include('is not included in the list')
    end

    it 'allows blank timezone' do
      user.timezone = ''
      expect(user).to be_valid
    end

    it 'allows valid timezone' do
      user.timezone = 'Australia/Sydney'
      expect(user).to be_valid
    end
  end

  describe '#count_hits' do
    subject(:user) { create(:user) }

    it 'counts hits for the current month' do
      create(:hit, user:)
      create(:hit, user:, created_at: 1.month.ago)
      expect(user.count_hits).to eq(1)
    end

    describe 'when user has no timezone' do
      before do
        # freeze time to the beginning of the month (Example: 2023-05-01 00:00:00 UTC)
        Timecop.freeze(Time.current.beginning_of_month)
      end

      after { Timecop.return }

      it 'counts only the hits current month' do
        # create the hits one second before the current time (Example: 2023-04-30 23:59:59 UTC)
        create_list(:hit, 10, user:, created_at: 1.second.ago) # wont be counted

        # create the hits at the current time (Example: 2023-05-01 00:00:00 UTC)
        create_list(:hit, 10, user:)
        expect(user.count_hits).to eq(10)
      end
    end

    describe 'when user has a timezone' do
      before do
        user.timezone = 'Australia/Sydney'
        # freeze time to the beginning of the month - 11 hours
        # (UTC: 2023-04-29 13:00:00 UTC)
        # (AEST: 2023-05-01 00:00:00 AEST)
        Time.use_zone(user.timezone) { Timecop.freeze(Time.zone.now.beginning_of_month) }
      end

      after { Timecop.return }

      it 'counts only the hits current month in the user timezone' do
        # create the hits one second before the current time
        # (UTC: 2023-04-30 12:59:59 UTC)
        # (AEST: 2023-04-30 23:59:59 AEST)
        create_list(:hit, 10, user:, created_at: 1.second.ago) # wont be counted
        # create the hits at the current time
        # (Example: 2023-04-30 13:00:00 UTC)
        # (Example: 2023-05-01 00:00:00 AEST)
        create_list(:hit, 10, user:)
        expect(user.count_hits).to eq(10)
      end

      # new month in Australia, but not in UTC
      describe 'when the hits are created after the end of the month in UTC' do
        describe 'when its the end of the month in the user timezone' do
          it 'counts the hits of the current month in the user timezone' do
            # freeze time in the end of the month (still should count as November period)
            # (UTC: 2023-11-30 23:59:59 UTC)
            # (AEST: 2023-12-01 10:59:59 AEST)
            Time.use_zone(user.timezone) { Timecop.freeze(Time.zone.now.end_of_month) }

            # create the hits at the current time
            # (UTC: 2023-11-30 23:59:59 UTC)
            # (AEST: 2023-12-01 10:59:59 AEST)
            create_list(:hit, 10, user:)

            # create the hits after the end of the month in AEST
            # (UTC: 2023-11-30 13:00:00 UTC)
            # (AEST: 2023-12-01 00:00:00 AEST)
            create_list(:hit, 10, user:, created_at: 1.second.from_now) # December hits, wont be counted
            expect(user.count_hits).to eq(10)
          end
        end

        describe 'when its the beginning of the month in the user timezone' do
          it 'counts the hits current month in the user timezone' do
            # freeze time in the end of the month (should count as December period)
            # (AEST: 2023-12-01 11:00:00 AEST)
            # (UTC: 2023-12-01 00:00:00 UTC)
            Time.use_zone(user.timezone) { Timecop.freeze(Time.zone.now.beginning_of_month) }

            # create the hits after the end of the month in AEST
            # (UTC: 2023-11-30 23:59:59 UTC)
            # (AEST: 2023-12-01 10:59:59 AEST)
            create_list(:hit, 10, user:, created_at: 1.second.ago) # November hits, wont be counted

            # create the hits at the current time
            # (UTC: 2023-12-01 00:00:00 UTC)
            # (AEST: 2023-12-01 11:00:00 AEST)
            create_list(:hit, 10, user:)

            expect(user.count_hits).to eq(10)
          end
        end
      end
    end
  end
end
