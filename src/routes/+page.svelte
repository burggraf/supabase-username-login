<script lang="ts">
	import { createClient, SupabaseClient } from '@supabase/supabase-js'
	const supabase: SupabaseClient = createClient('https://qmregqvlvbsiurgktjdg.supabase.co', 
	'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtcmVncXZsdmJzaXVyZ2t0amRnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Njc0OTUxMTgsImV4cCI6MTk4MzA3MTExOH0.gWgeSkw0-zURVV6OA7Ea0-fftUQR688NEuws0mgWTN4');
	const signUp = async () => {
		console.log('signing up');
		const username_input: any = document.getElementById('username');
		const password_input: any = document.getElementById('password');
		const username = username_input?.value;
		const password = password_input?.value;
		const { data, error } = await supabase.auth.signUp({
			email: username + '@fake-domain.com',
			password: password
		});
		console.log(data, error);

	}
	const signIn = async () => {
		console.log('signing in');
		const username_input: any = document.getElementById('username');
		const password_input: any = document.getElementById('password');
		const username = username_input?.value;
		const password = password_input?.value;
		const { data, error } = await supabase.auth.signInWithPassword({
			email: username + '@fake-domain.com',
			password: password
		});
		console.log(data, error);

}


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
</style>
