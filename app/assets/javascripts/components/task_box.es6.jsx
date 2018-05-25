class TaskBox extends React.Component {
  constructor (props) {
    super(props);
    let parsed_presenter = JSON.parse(props.presenter);
    this.state = {
      tasks: parsed_presenter.tasks,
      current_task: null,
      form: parsed_presenter.form,
      end_action: "",
      timer_string: "00:00:00",
      task_ended: true,
      timer_function: null
    }
  }

  handleTaskSubmit ( formData, action ) {
    $.ajax({
      data: formData,
      url: action,
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        console.log(data)
        this.setState({ current_task: data });
        this.setState({ task_ended: false });
        this.setState({ end_action: "/working_tasks/" + this.state.current_task.id + "/finish" });
        this.startTimer(Date.parse(new Date()));
      }.bind(this)
    });
  }

  handleEndTaskSubmit ( formData, action ) {
    $.ajax({
      data: formData,
      url: action,
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        var tasks = this.state.tasks;
        tasks.push(data);
        this.setState({ task_ended: true });
        this.setState({ tasks: tasks });

        this.setState({ timer_string: "00:00:00" });
        clearInterval(this.state.timer_function);
      }.bind(this)
    });
  }

  startTimer (startTime) {
    if(this.state.current_task){
      this.state.timer_function = setInterval(function(){
        var t = Date.parse(new Date()) - startTime;

        var seconds = Math.floor( (t / 1000) % 60 );
        seconds = ("0" + seconds).slice(-2);

        var minutes = Math.floor( (t/(1000*60)) % 60 );
        minutes = ("0" + minutes).slice(-2);

        var hours = Math.floor( (t/(1000*60*60)) % 24 );
        hours = ("0" + hours).slice(-2);

        this.setState({ timer_string: "" + hours + ":" + minutes + ":" + seconds });
      }.bind(this),1000);
    }

    return false;
  }

  render () {
    if(this.state.task_ended == true) {
      return (
        <div className="content">
          <TaskForm form={ this.state.form } onTaskSubmit={ this.handleTaskSubmit.bind(this) } />
          <TasksList tasks={ this.state.tasks } />
        </div>
      )
    } else {
      return (
        <div className="content">
          <EndTaskForm timer={ this.state.timer_string } task={ this.state.current_task } action={ this.state.end_action } form={ this.state.form } onTaskSubmit={ this.handleEndTaskSubmit.bind(this) } />
          <TasksList tasks={ this.state.tasks } />
        </div>
      )
    }
  }
};
