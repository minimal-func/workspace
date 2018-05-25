class TasksList extends React.Component {
  render () {
    let sortedTasks = this.props.tasks.sort(function(a, b) { return b.id - a.id });

    let TaskDate = []

    let tasks = sortedTasks.map(function ( task ) {
      return <Task content={ task.content } startedAt={ task.started_at } finishedAt={ task.finished_at } key={ task.id } />
    });

    return (
      <div className="task-list">
        <table className="result-table">
          <tbody>
            { tasks }
          </tbody>
        </table>
      </div>
    )
  }
}
