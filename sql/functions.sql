-- drop function handle_auth_user_created cascade;

create function public.handle_auth_user_created() 
returns trigger as $$
begin
  if (NEW.email ~* '.*?@fake-domain.com') 
  then
    NEW.confirmed_at := now();
    NEW.confirmation_sent_at := now();
    NEW.email_confirmed_at := now();
  end if;
  return NEW;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  before insert on auth.users
  for each row execute procedure public.handle_auth_user_created();
