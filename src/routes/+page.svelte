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
	const isValidEmail = (email: string) => {
		return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
	}
	const signUp = async () => {
		console.log('signing up');
		const username_input: any = document.getElementById('username');
		const password_input: any = document.getElementById('password');
		const error_message: any = document.getElementById('error');
		const notes: any = document.getElementById('notes');
		notes.innerHTML = '';
		const username = username_input?.value.trim().toLowerCase();
		const password = password_input?.value;
		if (username.indexOf('@') === -1) { // username sign up
			notes.innerHTML = 'User is signing up with username.<br/>';
			if (userNameCheck(username)) {
				error_message.innerText = userNameCheck(username);
				notes.innerHTML += 'Username check failed.<br/>';
			} else {
				error_message.innerText = '';
				const { data, error } = await supabase.auth.signUp({
					email: username + '@fake-domain.com',
					password: password
				});
				console.log(data, error);
				if (data?.user) {
					notes.innerHTML += 'User signed up.<br/>';
					currentUser = data.user;
				} else {
					notes.innerHTML += 'User sign up failed.<br/>';
					error_message.innerText = error?.message;
				}
			}
		} else { // email sign up
			notes.innerHTML = 'User is signing up with email.<br/>';
			if (!isValidEmail(username)) {
				error_message.innerText = 'Invalid email address';
				notes.innerHTML += 'Email check failed.<br/>';
			} else {
				error_message.innerText = '';
				const { data, error } = await supabase.auth.signUp({
					email: username,
					password: password
				});
				console.log(data, error);
				if (data?.user) {
					notes.innerHTML += 'User signed up.<br/>';
					currentUser = data.user;
					if (!currentUser.email_confirmed_at){
						error_message.innerText = 'Please check your email to confirm your account.';
						notes.innerHTML += 'User email not confirmed.<br/>';
					}
				} else {
					notes.innerHTML += 'User sign up failed.<br/>';
					notes.innerHTML += error?.message + '<br/>';
					error_message.innerText = error?.message;
				}
			}
		}
	}
	const signIn = async () => {
		console.log('signing in');
		const username_input: any = document.getElementById('username');
		const password_input: any = document.getElementById('password');
		const error_message: any = document.getElementById('error');
		const notes: any = document.getElementById('notes');
		notes.innerHTML = '';
		const username = username_input?.value.trim().toLowerCase();
		const password = password_input?.value;
		if (username.indexOf('@') === -1) { // username sign in
			notes.innerHTML = 'User is signing in with username.<br/>';
			if (userNameCheck(username)) {
				error_message.innerText = userNameCheck(username);
				notes.innerHTML += 'Username check failed.<br/>';
			} else {
				error_message.innerText = '';
				const { data, error } = await supabase.auth.signInWithPassword({
					email: username + '@fake-domain.com',
					password: password
				});
				console.log(data, error);
				if (data?.user) {
					notes.innerHTML += 'User signed in.<br/>';
					currentUser = data.user;
				} else {
					notes.innerHTML += 'User sign in failed.<br/>';
					notes.innerHTML += error?.message + '<br/>';
					error_message.innerText = error?.message;
				}
			}
		} else { // email sign in
			notes.innerHTML = 'User is signing in with email.<br/>';
			if (!isValidEmail(username)) {
				error_message.innerText = 'Invalid email address';
				notes.innerHTML += 'Email check failed.<br/>';
			} else {
				error_message.innerText = '';
				const { data, error } = await supabase.auth.signInWithPassword({
					email: username,
					password: password
				});
				console.log(data, error);
				if (data?.user) {
					notes.innerHTML += 'User signed in.<br/>';
					currentUser = data.user;
				} else {
					notes.innerHTML += 'User sign in failed.<br/>';
					notes.innerHTML += error?.message + '<br/>';
					error_message.innerText = error?.message;
				}
			}
		}
}
const signOut = async () => {
	console.log('signing out');
	const { error } = await supabase.auth.signOut()
	console.log(error);
	currentUser = null;
}

const getUser = async () => {
	const { data: { user } } = await supabase.auth.getUser()
	currentUser = user;
}

onMount(() => {
	const keys = Object.keys(localStorage);
	const key = keys.find((key) => key.endsWith('-auth-token'));
	if (key) { // we have a token stored in localStorage
		getUser();
	}
  });
</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="Svelte demo app" />
</svelte:head>

<main>
	<h1>Demo: Supabase Login with Username</h1>

	<!-- create table with no lines and no padding -->
	<table style="border: 0; padding: 0;">
		<tr>
			<td style="border: 0;">
				Username or Email<br /><input id="username" type="text" placeholder="username" /><br />
				<br />
				Password<br /><input id="password" type="password" placeholder="password" /><br />
				<br /><br />
				<button on:click={signUp}>Sign Up</button><br /><br />
				<button on:click={signIn}>Sign In</button><br /><br />
				<button on:click={signOut}>Sign Out</button>			
			</td>
			<td style="border: 0; padding: 2em; vertical-align: top;">
				<div id="notes" class="notes"></div>
			</td>
		</tr>
	</table>

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
	.notes {
		color: blue;
		font-size: larger;
	}
</style>
