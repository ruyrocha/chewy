require 'chewy/rake_helper'

namespace :chewy do
  desc 'Destroy, recreate and import data to specified index'
  task reset: :environment do |_task, args|
    Chewy::RakeHelper.subscribed_task_stats do
      indexes = args.extras

      if indexes.empty? || indexes.first.tr!('-', '')
        Chewy::RakeHelper.reset_all(indexes)
      else
        Chewy::RakeHelper.reset_index(indexes)
      end
    end
  end

  desc 'Updates data specified index'
  task update: :environment do |_task, args|
    Chewy::RakeHelper.subscribed_task_stats do
      indexes = args.extras

      if indexes.empty? || indexes.first.tr!('-', '')
        Chewy::RakeHelper.update_all(indexes)
      else
        Chewy::RakeHelper.update_index(indexes)
      end
    end
  end

  desc 'Applies changes that were done from specified moment (as a timestamp)'
  task apply_changes_from: :environment do |_task, args|
    Chewy::RakeHelper.subscribed_task_stats do
      timestamp = args.extras

      if timestamp.empty?
        puts 'Please specify a timestamp like chewy:apply_changes_from[1469528705]'
      else
        time = Time.at(timestamp.first.to_i)
        Chewy::Journal.apply_changes_from(time)
      end
    end
  end

  desc 'Cleans journal index. It accepts timestamp until which journal will be cleaned'
  task clean_journal: :environment do |_task, args|
    timestamp = args.extras.first
    if timestamp
      Chewy::Journal.clean_until(Time.at(timestamp.to_i))
    else
      Chewy::Journal.delete!
    end
  end
end
