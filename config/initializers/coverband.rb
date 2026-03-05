# Disable Coverband in test environment to avoid conflicts with SimpleCov
ENV["COVERBAND_DISABLE_AUTO_START"] = "1" if Rails.env.test?
