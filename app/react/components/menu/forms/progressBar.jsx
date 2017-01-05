import React from 'react';
import LinearProgress from 'material-ui/LinearProgress';
import CircularProgress from 'material-ui/CircularProgress';

export default class ProgressBar extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            completed: 0,
        };
    }

    componentDidMount() {
        this.setState({completed: 0});
    }

    componentDidUpdate() {

        const hostTableLenght = this.props.hostTableLenght
        const scannAmount = this.props.scannAmount

        let progressValue = hostTableLenght === 0 ? 0 : (hostTableLenght / scannAmount) * 100
        progressValue = Math.round(progressValue)
        progressValue === this.state.completed ? {} : this.setState({ completed: progressValue })
    }

    render() {

        return (
            <LinearProgress mode="determinate" value={this.state.completed} />
        )

        //todo loading indicator MAREK
        // this.state.completed === 100 ? return (
        //         <LinearProgress mode="determinate" value={this.state.completed} />
        // ) : return (
        //     <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end', height: 50 }}>
        //         <LinearProgress mode="determinate" value={this.state.completed} />
        //         <CircularProgress />
        //     </div>
        //
        // )
    }
}