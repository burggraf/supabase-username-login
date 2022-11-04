<script lang="ts">
	import { createClient, SupabaseClient, type User } from '@supabase/supabase-js'
  	import { onMount } from 'svelte'
	const supabase: SupabaseClient = 
		createClient(
			import.meta.env.VITE_SUPABASE_URL, 
			import.meta.env.VITE_SUPABASE_KEY
		);
	let currentUser: User | null = null;
	const userNameCheck = (username: string) => {
		if (username.length < 3 || username.length > 20)
		return "Username must be between 3 and 20 characters";
		if (username.indexOf(' ') > -1)
		return "Username cannot contain spaces";
		if (username.indexOf('@') > -1)
		return "Username cannot contain @";
		// only allow valid email characters
		if (!/^[a-z0-9_]+$/.test(username))
		return "Username can only contain letters, numbers, and underscores";
		return null;
	}
	const signUp = async () => {
		console.log('signing up');
		const username_input: any = document.getElementById('username');
		const password_input: any = document.getElementById('password');
		const error_message: any = document.getElementById('error');
		const username = username_input?.value.trim().toLowerCase();
		const password = password_input?.value;
		if (userNameCheck(username)) {
			error_message.innerText = userNameCheck(username);
		} else {
			error_message.innerText = '';
			const { data, error } = await supabase.auth.signUp({
				email: username + '@fake-domain.com',
				password: password
			});
			console.log(data, error);
			if (data?.user) {
				currentUser = data.user;
			}
		}
	}
	const signIn = async () => {
		console.log('signing in');
		const username_input: any = document.getElementById('username');
		const password_input: any = document.getElementById('password');
		const error_message: any = document.getElementById('error');
		const username = username_input?.value.trim().toLowerCase();
		const password = password_input?.value;
		if (userNameCheck(username)) {
			error_message.innerText = userNameCheck(username);
		} else {
			error_message.innerText = '';
			const { data, error } = await supabase.auth.signInWithPassword({
				email: username + '@fake-domain.com',
				password: password
			});
			console.log(data, error);
			if (data?.user) {
				currentUser = data.user;
			}
		}
}

const getUser = async () => {
	const { data: { user } } = await supabase.auth.getUser()
	currentUser = user;
}

onMount(() => {
    getUser();
  });
</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="Svelte demo app" />
</svelte:head>

<main>
	<h1>Demo: Supabase Login with Username</h1>
	Username<br /><input id="username" type="text" placeholder="username" /><br />
	<br />
	Password<br /><input id="password" type="password" placeholder="password" /><br />
	<br /><br />
	<button on:click={signUp}>Sign Up</button><br /><br />
	<button on:click={signIn}>Login</button>
	<br /><br />
	<div class="error" id="error"></div>
	<br />
	<h3>Current User:</h3>
	<pre>{JSON.stringify(currentUser, null, 2)}</pre>
</main>
<style>
	main {
		padding: 1em;
	}
	input {
		/* rounded corners */
		border-radius: 0.5em;
		height: 2em;
	}
	button {
		/* rounded corners */
		border-radius: 0.5em;
		height: 2em;
		width: 150px;
	}
	.error {
		color: red;
		font-size: larger;
	}
</style>
