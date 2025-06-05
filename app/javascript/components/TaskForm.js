import React from "react"

class TaskForm extends React.Component {
  handleSubmit (event) {
    event.preventDefault();
    var text = this.refs.task_content.value;
    // validate
    if (!text)
      return false;
    // submit
    const form = this.refs.form;
    const formData = new URLSearchParams(new FormData(form)).toString();
    this.props.onTaskSubmit( formData, this.props.form.action );
  }

  render () {
    return (
      <div className="form">
        <form ref="form" className="row" action={ this.props.form.action } acceptCharset="UTF-8" method="post" onSubmit={ this.handleSubmit.bind(this) } >
          <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
          <div className="col-md-8">
            <div className="row">
              <div className="col-md-10">
                <input type="text" ref="task_content" className="task_content" name="task[content]" placeholder="Type your current task..." />
              </div>
              <div className="col-md-2">
                <div className="timer">00:00:00</div>
              </div>
            </div>
          </div>
          <div className="col-md-4">
            <button className="btn btn--primary type--uppercase" type="submit">Start</button>
          </div>
        </form>
      </div>
    )
  }
}

export default TaskForm
