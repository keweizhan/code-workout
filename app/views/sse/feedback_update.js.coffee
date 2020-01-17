$("#saved_assurance").html("")
$("#exercisefeedback").html("<%= j(render 'ajax_feedback' ) %>")

attempt_score = <%= @attempt.score %>
max_points = <%= @max_points %>
attempts_exhausted = <%= @attempts_exhausted %>

if attempt_score >= max_points
  $("#nextbtn").removeClass("btn-next")
  $("#nextbtn").removeClass("btn-default")
  $("#nextbtn").addClass("btn-primary")
  $("#primarybtn").removeClass("btn-primary")
  $("#primarybtn").addClass("btn-default")

$('#sidebar').html("<%= j(render 'layouts/sidebar' ) %>")
subbtn = $('.btn-submit')
if subbtn? && !attempts_exhausted
  subbtn.removeAttr('disabled')
  $('#visualize').removeAttr('disabled')

editor = codemirrors[0].editor
for widget in editor.widgets
  editor.removeLineWidget(widget);
editor.widgets.length = 0

attempt_error = '<%= @attempt.prompt_answers.first.specific.error %>'
if attempt_error
  # Need to fix this to use a colon, but that isn't working in the
  # regex match?
  m = attempt_error.match(/^line.\s*(\d+)/i)
  if m
    n = parseInt(m[1]) - 1;
    widget = $('<div class="error-widget">' +
      '<i class="fa fa-times-circle"></i> ' +
      attempt_error + '</div>')
    editor.widgets.push(editor.addLineWidget(n, widget[0]))

tcrs = <%= raw @attempt.prompt_answers.first.specific.test_case_results(true).
           where.not(execution_feedback: :null).
          select("test_case_id, execution_feedback").to_json %>;
for tcr in tcrs
  if tcr.execution_feedback.match(/Lines: \d+/)
    line = tcr.execution_feedback.split "Lines: "
    for line_num in line[1].split ", "
      widget = $('<div class="error-widget"></div>')
      widget.text("Error: " + line[0])
      editor.widgets.push(editor.addLineWidget(parseInt(line_num, 10) - 1, widget[0]))
