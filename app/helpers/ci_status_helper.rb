#encoding: utf-8
module CiStatusHelper
  def ci_status_path(ci_commit)
    project = ci_commit.project
    builds_namespace_project_commit_path(project.namespace, project, ci_commit.sha)
  end

  def ci_status_icon(ci_commit)
    ci_icon_for_status(ci_commit.status)
  end

  def ci_status_label(ci_commit)
    ci_label_for_status(ci_commit.status)
  end

  def ci_status_with_icon(status, target = nil)
    content = ci_icon_for_status(status) + '&nbsp;'.html_safe + ci_label_for_status(status)
    klass = "ci-status ci-#{status}"
    if target
      link_to content, target, class: klass
    else
      content_tag :span, content, class: klass
    end
  end

  def ci_label_for_status(status)
    if status == 'success'
      '通过'
    else
      ci_status_zh(status)
    end
  end

  def ci_icon_for_status(status)
    icon_name =
      case status
      when 'success'
        'check'
      when 'failed'
        'close'
      when 'running', 'pending'
        'clock-o'
      else
        'circle'
      end

    icon(icon_name + ' fw')
  end

  def ci_status_zh(status)
    case status
    when 'pending'
      '排队'
    when 'running'
      '运行'
    when 'success'
      '成功'
    when 'failed'
      '失败'
    when 'canceled'
      '取消'
    else
      '未知'
    end
  end

  def render_ci_status(ci_commit, tooltip_placement: 'auto left')
    link_to ci_status_icon(ci_commit),
      ci_status_path(ci_commit),
      class: "ci-status-link ci-status-icon-#{ci_commit.status.dasherize}",
      title: "构建状态：#{ci_status_label(ci_commit)}",
      data: { toggle: 'tooltip', placement: tooltip_placement }
  end

  def no_runners_for_project?(project)
    project.runners.blank? &&
      Ci::Runner.shared.blank?
  end
end
