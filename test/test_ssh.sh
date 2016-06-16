#!/bin/bash
script_dir="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
. "$script_dir/assert.sh"
. "$script_dir/../core/.magritte/util/ssh.sh"

# If ssh-add -L exits with 2 ("Couldn't connect to ssh-agent"),
# require_ssh_keys tells the user to start ssh-agent and exits with 1.
ssh_add_exit_code=2
assert_raises 'require_ssh_keys 2>&1 | grep "command to start"' 0
assert_raises 'require_ssh_keys' 1

# If ssh-add -L exits with 0 but its output doesn't contain the user's public
# key, require_ssh_keys tells the user to add the key to ssh-agent and exits
# with 1.
pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD7e4uLtsLxZ16xc3WhRZGK7mXWVGuPRV3hhYj71W5qKu5RWM3RLA+SW/ljtmuUroNidzgL6ANZF8fz9FBr8CYpVwAS3dXqhCuYQBNRNpByZKjM6ZbXas2ugtSil3HI0yB67FqBBE9FQp5p28KTsbno2ZQVVXg0Jy5e0EMVrnw0sYrceEwl/K/nJDxO70lUbxgyhl9MkULEok18ax/lMTIB12JseuMKZjnl5vPkHIGMrEbQzN4pV3ALyysEfHf15KlAtKymzZuVikzVj/9dYus5vvW2C+B80Aii7Lt+wDt5trT3PCmnXeQEn54XiWnaBKARZ7VekV3jbQiJeclThaNkls6GntAwN+ND7JUjqft1AQt0bjIi7OB+jxYNpuHMAgKJVAMtxLE7kCfR4yep4KNxIzAmil03XBjtgrsE2NMiTQCXohw4S2yCe5SNcwUj4XvxnkCJMq/tkie8vKQS1tpV/Wsm5o8wqaIWYLaTomKm/lWA2COgPIPE3Dc4iBkRJRanW9gegrS2ZnnpHsV6+rsjy8JboiOP4CThihWi+xJUqWuhnG3uXUqyacBH0V0p/UnJ/OSeoIXsbj9e7fMtEN91QuWH7UvkJhqBKANccwH5mzoI40FKmxuYHFX3POWYLocnVVBPm58Hh7JhnG6zwg2+hSe07AFexYa6fdy+JyoQ8w== b@example.com"
ssh_add_exit_code=0
ssh_add_output="\
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDq6YelV0+s+vxnDcZ5QqsLybXksapp89NdfDMmm7EjphIXxcbDny8oH9F4Z/LBLxQpL1dZnbOn1A4NzeYQvbD7As8jVliI/43ivErYseMKh6UDoa/26fSyUB5V3j99CF9LIIkHMgfTiK2zKtK3PKGyWAjWCWOY9eF5js3yP3FEguRnKCxh0YBXHijn+/tKgnEn32vvM3RTUU3Wz6Mcq4AQhm7wrN1NWeXp0t+C7+ossylMdrCyZiwpYpZh5D/fjvByi+IIDevKmNyGg4huK0UKT1ckfrefa5pleVNYssyREqoot0sY0rHnwJx36ht/GjBc5phFbX0Nyx0mEZtB0JcJbihZbB7SYJfQNXvDfK2ZmmPotHC5zf6+1laK8GzFM+SZJnkr1raxNncbxFF6gzVowxvMBRCDEh0MnGOLVg+ViLGXpJEhlmwrftJm1OCp56BSeIZDauojJWtpBi5Ct8CedmI7/iH7Kd1xWrW15P5DCg03Nvb9oHNWNvl5TGdIDXnjMVbv/qTRY85byVB95Fk+ZJHg1SC0WIN5IBLWRzhODNR+F9Am/QzVEcdojZcHdAe3mWC5wCfgd0zvY0tohvGn/TyoGqFXobQJA/trcwsTUG+0l+ZI/jjGjlYytCqHULkXJVLNkl/FHraBIK/l+P8v0fK0EzSCV0M1RBlCPz30OQ== ~/.ssh/a"
assert_raises 'require_ssh_keys 2>&1 | grep "command to add"' 0
assert_raises 'require_ssh_keys' 1

# If ssh-add -L exits with 0 and its output contains the user's public key,
# require_ssh_keys exits silently with 0.
ssh_add_exit_code=0
ssh_add_output="\
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDq6YelV0+s+vxnDcZ5QqsLybXksapp89NdfDMmm7EjphIXxcbDny8oH9F4Z/LBLxQpL1dZnbOn1A4NzeYQvbD7As8jVliI/43ivErYseMKh6UDoa/26fSyUB5V3j99CF9LIIkHMgfTiK2zKtK3PKGyWAjWCWOY9eF5js3yP3FEguRnKCxh0YBXHijn+/tKgnEn32vvM3RTUU3Wz6Mcq4AQhm7wrN1NWeXp0t+C7+ossylMdrCyZiwpYpZh5D/fjvByi+IIDevKmNyGg4huK0UKT1ckfrefa5pleVNYssyREqoot0sY0rHnwJx36ht/GjBc5phFbX0Nyx0mEZtB0JcJbihZbB7SYJfQNXvDfK2ZmmPotHC5zf6+1laK8GzFM+SZJnkr1raxNncbxFF6gzVowxvMBRCDEh0MnGOLVg+ViLGXpJEhlmwrftJm1OCp56BSeIZDauojJWtpBi5Ct8CedmI7/iH7Kd1xWrW15P5DCg03Nvb9oHNWNvl5TGdIDXnjMVbv/qTRY85byVB95Fk+ZJHg1SC0WIN5IBLWRzhODNR+F9Am/QzVEcdojZcHdAe3mWC5wCfgd0zvY0tohvGn/TyoGqFXobQJA/trcwsTUG+0l+ZI/jjGjlYytCqHULkXJVLNkl/FHraBIK/l+P8v0fK0EzSCV0M1RBlCPz30OQ== ~/.ssh/a
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD7e4uLtsLxZ16xc3WhRZGK7mXWVGuPRV3hhYj71W5qKu5RWM3RLA+SW/ljtmuUroNidzgL6ANZF8fz9FBr8CYpVwAS3dXqhCuYQBNRNpByZKjM6ZbXas2ugtSil3HI0yB67FqBBE9FQp5p28KTsbno2ZQVVXg0Jy5e0EMVrnw0sYrceEwl/K/nJDxO70lUbxgyhl9MkULEok18ax/lMTIB12JseuMKZjnl5vPkHIGMrEbQzN4pV3ALyysEfHf15KlAtKymzZuVikzVj/9dYus5vvW2C+B80Aii7Lt+wDt5trT3PCmnXeQEn54XiWnaBKARZ7VekV3jbQiJeclThaNkls6GntAwN+ND7JUjqft1AQt0bjIi7OB+jxYNpuHMAgKJVAMtxLE7kCfR4yep4KNxIzAmil03XBjtgrsE2NMiTQCXohw4S2yCe5SNcwUj4XvxnkCJMq/tkie8vKQS1tpV/Wsm5o8wqaIWYLaTomKm/lWA2COgPIPE3Dc4iBkRJRanW9gegrS2ZnnpHsV6+rsjy8JboiOP4CThihWi+xJUqWuhnG3uXUqyacBH0V0p/UnJ/OSeoIXsbj9e7fMtEN91QuWH7UvkJhqBKANccwH5mzoI40FKmxuYHFX3POWYLocnVVBPm58Hh7JhnG6zwg2+hSe07AFexYa6fdy+JyoQ8w== ~/.ssh/b"
assert 'require_ssh_keys 2>&1' ''
assert_raises 'require_ssh_keys' 0

assert_end