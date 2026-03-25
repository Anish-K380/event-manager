import {api} from './api.jsx';

export const CreateUser = async (username, password) => {
    const response = await fetch(`${api}/signup`, {
	method: 'POST',
	headers: {
	    'Content-type': 'application/json'
	},
	body: JSON.stringify({username, password})
    });

    return response.json();
};
