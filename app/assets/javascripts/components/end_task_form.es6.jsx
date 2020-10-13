class EndTaskForm extends React.Component {
  handleSubmit (event) {
    event.preventDefault();
    // submit
    var formData = $(this.refs.end_form).serialize();
    this.props.onTaskSubmit( formData, this.props.action );
  }

  render () {
    var content_string = this.props.task && this.props.task.content || "";
    var overall_content_string = "Current task: " + content_string;

    return (
      <div className="form">
        <form ref="end_form" action={ this.props.action } acceptCharset="UTF-8" method="post" onSubmit={ this.handleSubmit.bind(this) } >
          <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
          <input type="text" ref="task_description" className="task_description" name="task[description]" defaultValue={ overall_content_string } />
          <div className="button-holder">
            <div className="timer">{ this.props.timer }</div>
            <button className="button red">Stop</button>
          </div>
        </form>
      </div>
    )
  }
}
