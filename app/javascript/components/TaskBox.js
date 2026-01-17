import React from "react"
import EndTaskForm from './EndTaskForm'
import TaskForm from './TaskForm'
import TasksList from './TasksList'

class TaskBox extends React.Component {
  constructor (props) {
    super(props);
    let parsed_presenter = props.presenter;
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
    fetch(action, {
      method: "POST",
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      console.log(data)
      this.setState({ current_task: data });
      this.setState({ task_ended: false });
      this.setState({ end_action: "/timetracker/tasks/" + data.id + "/finish" });
      this.startTimer(Date.parse(new Date()));
    })
    .catch(error => console.error('Error:', error));
  }

  handleEndTaskSubmit ( formData, action ) {
    fetch(action, {
      method: "POST",
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      var tasks = this.state.tasks;
      tasks.push(data);
      this.setState({ task_ended: true });
      this.setState({ tasks: tasks });

      this.setState({ timer_string: "00:00:00" });
      clearInterval(this.state.timer_function);
    })
    .catch(error => console.error('Error:', error));
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
        <div className="row">
          <div className="col-md-12">
            <TaskForm form={ this.state.form } onTaskSubmit={ this.handleTaskSubmit.bind(this) } />
            <TasksList tasks={ this.state.tasks } />
          </div>
        </div>
      )
    } else {
      return (
        <div className="row">
          <div className="col-md-12">
            <EndTaskForm timer={ this.state.timer_string } task={ this.state.current_task } action={ this.state.end_action } form={ this.state.form } onTaskSubmit={ this.handleEndTaskSubmit.bind(this) } />
            <TasksList tasks={ this.state.tasks } />
          </div>
        </div>
      )
    }
  }
};

export default TaskBox
