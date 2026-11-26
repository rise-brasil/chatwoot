# rise-brasil: lets an installation show the dashboard inside another web system it runs,
# by naming the sites allowed to frame it in DASHBOARD_FRAME_ANCESTORS (origins separated by
# spaces or commas). Left unset, the Rails default X-Frame-Options: SAMEORIGIN stays, as on
# every other installation.
#
# Only dashboard pages are covered. The web widget and the help center set their own framing
# rules, and a custom-domain help center rendered from DashboardController keeps the default.
module DashboardFrameAncestors
  extend ActiveSupport::Concern

  included do
    after_action :allow_dashboard_framing
  end

  private

  def allow_dashboard_framing
    return if @portal

    ancestors = ENV.fetch('DASHBOARD_FRAME_ANCESTORS', '').split(/[\s,]+/).compact_blank
    return if ancestors.empty?

    response.headers.delete('X-Frame-Options')
    response.headers['Content-Security-Policy'] = "frame-ancestors 'self' #{ancestors.join(' ')}"
  end
end
