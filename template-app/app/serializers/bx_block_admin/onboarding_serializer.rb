module BxBlockAdmin
  class OnboardingSerializer < BuilderBase::BaseSerializer
    attributes :id, :title, :description

    attribute :steps_completed do |object|
      object.task_info.last
    end

    attribute :total_steps do |object|
      object.task_info.first
    end

    attribute :percent_completion do |object|
      total_steps, steps_completed = object.task_info
      begin
        (steps_completed.to_f/total_steps.to_f)*100
      rescue
        100
      end
    end

    attribute :steps do |object|
      steps = object.onboarding_steps
    end

  end
end