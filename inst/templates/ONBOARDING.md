### What exactly happens if I collaborate in a project? 

### Does it mean I'll break everything if I click the wrong button?

Concretely, if you accept an invitation to collaborate on a software team, these things happen:

* It lets you manage incoming issues on by labelling them, closing them, etc.
* It lets you merge pull requests by clicking Github's big green "Merge" button, but only if all their tests have passed.
* It automatically subscribes you to notifications (but you can unsubscribe again if you want through the Github interface).
* It does not allow you to push changes directly to Github without submitting a PR, and it doesn't let you merge broken PRs – this is enforced through Github's "branch protection" feature, and it applies to everyone from the newest contributor up to the project founder.

### Okay, that's what I CAN do, but what SHOULD I do?

Short answer: whatever you feel comfortable with.

We do have one rule, which is the same one most F/OSS projects use: don’t merge your own PRs. We find that having another person look at each PR leads to better quality. (Exception: you may see the project founder merging their own PRs if nobody can review them.)

Beyond that, it all comes down to what you feel up to. If you don't feel like you know enough to review a complex code change, then you don't have to – you can just look it over and make some comments, even if you don't feel up to making the final merge/no-merge decision. Or you can just stick to merging doc fixes and adding tags to issues, that's very helpful too. If after hanging around for a while you start to feel like you have better handle on how things work and want to start doing more, that’s excellent; if it doesn't happen, that's fine too.

If at any point you're unsure about whether doing something would be appropriate, feel free to ask (by posting Github comment). For example, it's totally OK if the first time you review a PR, you want someone else to check over your work before you hit the merge button.

---

Adapted from https://github.com/jimhester/lintr/issues/318 and https://trio.readthedocs.io/en/latest/contributing.html#joining-the-team.
