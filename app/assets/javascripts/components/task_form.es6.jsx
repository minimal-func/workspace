class TaskForm extends React.Component {
  handleSubmit (event) {
    event.preventDefault();
    var text = this.refs.working_task_content.value;
    // validate
    if (!text)
      return false;
    // submit
    var formData = $(this.refs.form).serialize();
    this.props.onTaskSubmit( formData, this.props.form.action );
  }

  render () {
    return (
      <div className="form">
        <form ref="form" action="" action={ this.props.form.action } acceptCharset="UTF-8" method="post" onSubmit={ this.handleSubmit.bind(this) } >
          <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
          <input type="text" ref="working_task_content" className="working_task_content" name="working_task[content]" placeholder="Type your current task..." />
          <div className="button-holder">
            <div className="timer">00:00:00</div>
            <button className="button">Start</button>
          </div>
        </form>
      </div>
    )
  }
}
