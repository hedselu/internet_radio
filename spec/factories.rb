FactoryGirl.define do
  factory :user do
    email 'sample_email@mail.com'
    password 'simple_password'

    factory :user_with_songs do
      transient do
        songs_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:song, evaluator.songs_count, user: user)
      end
    end

    factory :user_with_playlists_list do
      transient do
        playlists_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:playlists_list, evaluator.playlists_count, user: user)
      end
    end

    factory :user_with_single_playlist do
      transient do
        playlists_count 1
      end

      after(:create) do |user, evaluator|
        create_list(:playlist, evaluator.playlists_count, user: user)
      end
    end

    factory :user_with_channel do
      channel
    end
  end

  factory :playlist do
    name 'playlist_name'

    factory :playlists_list do
      sequence(:name) { |n| "name#{n}" }
      songs { |a| [a.association(:song)] }
    end
  end

  factory :song do
    factory :filed_songs_list do
      after :create do |b|
        b.update_column(:file, File.join(Rails.root, 'spec', 'fixtures', 'files', 'ruby_kaiser.mp3'))
      end
    end

    title 'song_title'
    author 'song_author'
  end

  factory :channel do
    name 'channel_name'
  end
end
