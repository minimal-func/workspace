class Task extends React.Component {
  render () {
    console.log(Date.parse(this.props.finishedAt))
    console.log(Date.parse(this.props.startedAt))
    let diff = Date.parse(this.props.finishedAt) - Date.parse(this.props.startedAt);
    var seconds = Math.floor( (diff / 1000) % 60 );
    seconds = ("0" + seconds).slice(-2);

    var minutes = Math.floor( (diff/(1000*60)) % 60 );
    minutes = ("0" + minutes).slice(-2);

    var hours = Math.floor( (diff/(1000*60*60)) % 24 );
    hours = ("0" + hours).slice(-2);

    let was = "" + hours + ":" + minutes + ":" + seconds;

    return (
      <tr>
        <td className="name">{ this.props.content }</td>
        <td className="time">{ was }</td>
        <td className="desc">{ this.props.startedAt }</td>
      </tr>
    );
  }
}
