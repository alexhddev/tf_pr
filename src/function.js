exports.handler = async (event) => {
    console.log('event', event);
    let response = 'Hello from Lambda! ';
    return response
}