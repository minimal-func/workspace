var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ("value" in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var EndTaskForm = (function (_React$Component) {
  _inherits(EndTaskForm, _React$Component);

  function EndTaskForm() {
    _classCallCheck(this, EndTaskForm);

    _get(Object.getPrototypeOf(EndTaskForm.prototype), "constructor", this).apply(this, arguments);
  }

  _createClass(EndTaskForm, [{
    key: "handleSubmit",
    value: function handleSubmit(event) {
      event.preventDefault();
      // submit
      var formData = $(this.refs.end_form).serialize();
      this.props.onTaskSubmit(formData, this.props.action);
    }
  }, {
    key: "render",
    value: function render() {
      var content_string = this.props.task && this.props.task.content || "";
      var overall_content_string = "Current task: " + content_string;

      return React.createElement(
        "div",
        { className: "form" },
        React.createElement(
          "form",
          { ref: "end_form", action: this.props.action, acceptCharset: "UTF-8", method: "post", onSubmit: this.handleSubmit.bind(this) },
          React.createElement("input", { type: "hidden", name: this.props.form.csrf_param, value: this.props.form.csrf_token }),
          React.createElement("input", { type: "text", ref: "task_description", className: "task_description", name: "task[description]", defaultValue: overall_content_string }),
          React.createElement(
            "div",
            { className: "button-holder" },
            React.createElement(
              "div",
              { className: "timer" },
              this.props.timer
            ),
            React.createElement(
              "button",
              { className: "button red" },
              "Stop"
            )
          )
        )
      );
    }
  }]);

  return EndTaskForm;
})(React.Component);
var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ("value" in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Task = (function (_React$Component) {
  _inherits(Task, _React$Component);

  function Task() {
    _classCallCheck(this, Task);

    _get(Object.getPrototypeOf(Task.prototype), "constructor", this).apply(this, arguments);
  }

  _createClass(Task, [{
    key: "render",
    value: function render() {
      console.log(Date.parse(this.props.finishedAt));
      console.log(Date.parse(this.props.startedAt));
      var diff = Date.parse(this.props.finishedAt) - Date.parse(this.props.startedAt);
      var seconds = Math.floor(diff / 1000 % 60);
      seconds = ("0" + seconds).slice(-2);

      var minutes = Math.floor(diff / (1000 * 60) % 60);
      minutes = ("0" + minutes).slice(-2);

      var hours = Math.floor(diff / (1000 * 60 * 60) % 24);
      hours = ("0" + hours).slice(-2);

      var was = "" + hours + ":" + minutes + ":" + seconds;

      return React.createElement(
        "tr",
        null,
        React.createElement(
          "td",
          { className: "name" },
          this.props.content
        ),
        React.createElement(
          "td",
          { className: "time" },
          was
        ),
        React.createElement(
          "td",
          { className: "desc" },
          this.props.startedAt
        )
      );
    }
  }]);

  return Task;
})(React.Component);
var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ("value" in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var TaskBox = (function (_React$Component) {
  _inherits(TaskBox, _React$Component);

  function TaskBox(props) {
    _classCallCheck(this, TaskBox);

    _get(Object.getPrototypeOf(TaskBox.prototype), "constructor", this).call(this, props);
    var parsed_presenter = JSON.parse(props.presenter);
    this.state = {
      tasks: parsed_presenter.tasks,
      current_task: null,
      form: parsed_presenter.form,
      end_action: "",
      timer_string: "00:00:00",
      task_ended: true,
      timer_function: null
    };
  }

  _createClass(TaskBox, [{
    key: "handleTaskSubmit",
    value: function handleTaskSubmit(formData, action) {
      $.ajax({
        data: formData,
        url: action,
        type: "POST",
        dataType: "json",
        success: (function (data) {
          console.log(data);
          this.setState({ current_task: data });
          this.setState({ task_ended: false });
          this.setState({ end_action: "/timetracker/tasks/" + this.state.current_task.id + "/finish" });
          this.startTimer(Date.parse(new Date()));
        }).bind(this)
      });
    }
  }, {
    key: "handleEndTaskSubmit",
    value: function handleEndTaskSubmit(formData, action) {
      $.ajax({
        data: formData,
        url: action,
        type: "POST",
        dataType: "json",
        success: (function (data) {
          var tasks = this.state.tasks;
          tasks.push(data);
          this.setState({ task_ended: true });
          this.setState({ tasks: tasks });

          this.setState({ timer_string: "00:00:00" });
          clearInterval(this.state.timer_function);
        }).bind(this)
      });
    }
  }, {
    key: "startTimer",
    value: function startTimer(startTime) {
      if (this.state.current_task) {
        this.state.timer_function = setInterval((function () {
          var t = Date.parse(new Date()) - startTime;

          var seconds = Math.floor(t / 1000 % 60);
          seconds = ("0" + seconds).slice(-2);

          var minutes = Math.floor(t / (1000 * 60) % 60);
          minutes = ("0" + minutes).slice(-2);

          var hours = Math.floor(t / (1000 * 60 * 60) % 24);
          hours = ("0" + hours).slice(-2);

          this.setState({ timer_string: "" + hours + ":" + minutes + ":" + seconds });
        }).bind(this), 1000);
      }

      return false;
    }
  }, {
    key: "render",
    value: function render() {
      if (this.state.task_ended == true) {
        return React.createElement(
          "div",
          { className: "content" },
          React.createElement(TaskForm, { form: this.state.form, onTaskSubmit: this.handleTaskSubmit.bind(this) }),
          React.createElement(TasksList, { tasks: this.state.tasks })
        );
      } else {
        return React.createElement(
          "div",
          { className: "content" },
          React.createElement(EndTaskForm, { timer: this.state.timer_string, task: this.state.current_task, action: this.state.end_action, form: this.state.form, onTaskSubmit: this.handleEndTaskSubmit.bind(this) }),
          React.createElement(TasksList, { tasks: this.state.tasks })
        );
      }
    }
  }]);

  return TaskBox;
})(React.Component);

;
var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ("value" in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var TaskForm = (function (_React$Component) {
  _inherits(TaskForm, _React$Component);

  function TaskForm() {
    _classCallCheck(this, TaskForm);

    _get(Object.getPrototypeOf(TaskForm.prototype), "constructor", this).apply(this, arguments);
  }

  _createClass(TaskForm, [{
    key: "handleSubmit",
    value: function handleSubmit(event) {
      event.preventDefault();
      var text = this.refs.task_content.value;
      // validate
      if (!text) return false;
      // submit
      var formData = $(this.refs.form).serialize();
      this.props.onTaskSubmit(formData, this.props.form.action);
    }
  }, {
    key: "render",
    value: function render() {
      return React.createElement(
        "div",
        { className: "form" },
        React.createElement(
          "form",
          { ref: "form", action: "", action: this.props.form.action, acceptCharset: "UTF-8", method: "post", onSubmit: this.handleSubmit.bind(this) },
          React.createElement("input", { type: "hidden", name: this.props.form.csrf_param, value: this.props.form.csrf_token }),
          React.createElement("input", { type: "text", ref: "task_content", className: "task_content", name: "task[content]", placeholder: "Type your current task..." }),
          React.createElement(
            "div",
            { className: "button-holder" },
            React.createElement(
              "div",
              { className: "timer" },
              "00:00:00"
            ),
            React.createElement(
              "button",
              { className: "button" },
              "Start"
            )
          )
        )
      );
    }
  }]);

  return TaskForm;
})(React.Component);
var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ("value" in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var TasksList = (function (_React$Component) {
  _inherits(TasksList, _React$Component);

  function TasksList() {
    _classCallCheck(this, TasksList);

    _get(Object.getPrototypeOf(TasksList.prototype), "constructor", this).apply(this, arguments);
  }

  _createClass(TasksList, [{
    key: "render",
    value: function render() {
      var sortedTasks = this.props.tasks.sort(function (a, b) {
        return b.id - a.id;
      });

      var TaskDate = [];

      var tasks = sortedTasks.map(function (task) {
        return React.createElement(Task, { content: task.content, startedAt: task.started_at, finishedAt: task.finished_at, key: task.id });
      });

      return React.createElement(
        "div",
        { className: "task-list" },
        React.createElement(
          "table",
          { className: "result-table" },
          React.createElement(
            "tbody",
            null,
            tasks
          )
        )
      );
    }
  }]);

  return TasksList;
})(React.Component);
